require 'puma/plugin'

Puma::Plugin.create do
  def production?
    ENV.fetch('RAILS_ENV', 'development') == 'production' || ENV.fetch('RAILS_ENV', 'development') == 'staging'
  end

  def log(msg)
    if production?
      Rails.logger.info msg
    else
      puts msg
    end
  end

  def flush
    Rails.logger.flush if production?
  end

  def start(launcher)
    in_background do
      loop do
        sleep ENV.fetch('PUMA_STATS_FREQUENCY', 60).to_i

        begin
          stats = JSON.parse Puma.stats, symbolize_names: true

          if stats[:worker_status]
            stats[:worker_status].each do |worker|
              stat = worker[:last_status]
              log "source=worker.#{worker[:pid]} sample#puma.backlog=#{stat[:backlog]} sample#puma.running=#{stat[:running]} sample#puma.pool_capacity=#{stat[:pool_capacity]}"
            end
          else
            log "sample#puma.backlog=#{stats[:backlog]} sample#puma.running=#{stats[:running]} sample#puma.pool_capacity=#{stats[:pool_capacity]}"
          end

          db_pool = ActiveRecord::Base.connection_pool.stat
          log "sample#db_pool.size=#{db_pool[:size]} sample#db_pool.connections=#{db_pool[:connections]} sample#db_pool.busy=#{db_pool[:busy]} sample#db_pool.dead=#{db_pool[:dead]} sample#db_pool.idle=#{db_pool[:idle]} sample#db_pool.waiting=#{db_pool[:waiting]}"

          flush
        rescue => e
          # Rollbar.error(e) if production?
          log e
        end
      end
    end
  end
end
