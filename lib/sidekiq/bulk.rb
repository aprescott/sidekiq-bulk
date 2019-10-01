require "sidekiq"

module SidekiqBulk
  def push_bulk(items, limit: 10_000, &block)
    job_ids = items.each_slice(limit).map do |group|
      push_bulk!(group, &block)
    end

    job_ids.flatten
  end

  def push_bulk!(items, &block)
    if block
      args = items.map(&block)
    else
      args = items.map { |el| [el] }
    end

    Sidekiq::Client.push_bulk("class" => self, "args" => args)
  end

  def push_bulk_in(interval, items, limit: 10_000, &block)
    int = interval.to_f
    now = Time.now.to_f
    timestamp = (int < 1_000_000_000 ? now + int : int)

    job_ids = items.each_slice(limit).map do |group|
      push_bulk_in!(timestamp, group, &block)
    end

    job_ids.flatten
  end

  def push_bulk_in!(timestamp, items, &block)
    if block
      args = items.map(&block)
    else
      args = items.map { |el| [el] }
    end

    Sidekiq::Client.push_bulk("class" => self, "args" => args, "at" => timestamp)
  end
end

Sidekiq::Worker::ClassMethods.module_eval { include SidekiqBulk }
