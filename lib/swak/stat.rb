module Swak
  module Stat

    class GaussianDistribution
      attr_reader :mean, :stddev, :variance, :rng

      def initialize(mean=0.0, stddev=1.0, rng = lambda { Kernel.rand })
        if stddev <= 0.0
          raise ArgumentError, "Nonpositive stddev"
        end
        @mean, @stddev, @rng = mean, stddev, rng
        @variance = stddev * stddev
        @regen = false
      end

      def rand
        # Uses Box-Muller transforms in polar form
        # See http://en.wikipedia.org/wiki/Box-Muller_transform#Polar_form
        if (@regen = !@regen)
          s, u, v = 0, 0, 0
          while s == 0 or s >= 1
            u = 2.0 * @rng.call - 1.0
            v = 2.0 * @rng.call - 1.0
            s = u * u + v * v
          end

          w = Math.sqrt((-2.0 * Math.log(s)) / s)
          y = u * w
          @other = v * w
        else
          y = @other
        end
        return @mean + y * @stddev
      end

    end

  end
end
