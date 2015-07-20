RSpec.describe SidekiqBulk do
  class FooJob
    include Sidekiq::Worker

    def perform(x, *args)
      raise x.to_s
    end
  end

  class BarJob < FooJob
  end

  it "provides a push_bulk method on job classes" do
    expect(FooJob).to respond_to(:push_bulk)
  end

  it "enqueues the job" do
    FooJob.push_bulk([1, 2, 3]) { |el| [el, "some-value"] }

    expect(FooJob.jobs.length).to eq(3)
    expect(FooJob).to have_enqueued_job(1, "some-value")
    expect(FooJob).to have_enqueued_job(2, "some-value")
    expect(FooJob).to have_enqueued_job(3, "some-value")
  end

  it "goes through the Sidekiq::Client interface" do
    expect(Sidekiq::Client).to receive(:push_bulk).with("class" => FooJob, "args" => [[1], [2], [3]])

    FooJob.push_bulk([1, 2, 3])
  end

  it "uses the correct class name for subclasses" do
    expect(Sidekiq::Client).to receive(:push_bulk).with("class" => BarJob, "args" => [[1], [2], [3]])

    BarJob.push_bulk([1, 2, 3])
  end

  it "defaults to the identity function with no block given" do
    FooJob.push_bulk([1, 2, 3])

    expect(FooJob.jobs.length).to eq(3)
    expect(FooJob).to have_enqueued_job(1)
    expect(FooJob).to have_enqueued_job(2)
    expect(FooJob).to have_enqueued_job(3)
  end

  describe "inline test", sidekiq: :inline do
    specify { expect { FooJob.push_bulk([1, 2, 3]) }.to raise_error(RuntimeError, "1") }
  end
end
