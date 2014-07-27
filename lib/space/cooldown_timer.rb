module Space
  class CooldownTimer

    attr_reader :last_trigger, :cooldown

    def initialize(cooldown = 0.1)
      @cooldown     = cooldown
      @last_trigger = Time.now - @cooldown
    end

    def ready?
      Time.now - last_trigger > cooldown
    end

    def trigger
      return unless ready?
      @last_trigger = Time.now
    end
  end
end
