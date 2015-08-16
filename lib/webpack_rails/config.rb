module WebpackRails
  module Config
    def self.merge(*hashs)
      hashs.inject({}) do |acc, hash|
        merge2(acc, hash)
      end
    end

    def self.merge2(value1, value2)
      case
      when value1.is_a?(Hash) && value2.is_a?(Hash)
        result = value1.deep_dup

        value2.each do |k, v|
          if result.has_key?(k)
            result[k] = merge2(result[k], v)
          else
            result[k] = v
          end
        end

        result
      when value1.is_a?(Array) || value2.is_a?(Array)
        Array(value1) + Array(value2)
      else
        value2
      end
    end
  end
end
