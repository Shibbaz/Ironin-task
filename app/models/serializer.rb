class Serializer
    attr_accessor :object

    @@attributes = Hash.new { |k, v| k[v] = {} }

    def initialize(struct)
        @object = struct
    end
    
    def self.attribute(attribute, &bloc)
        @@attributes[self.to_s][attribute] = bloc
    end

    def serialize
        data = @@attributes[self.class.to_s]

        data.keys.each_with_object({}) do |attribute, result|
            bloc = data[attribute]
            save(attribute, result, bloc)
        end
    end

    private

    def value(bloc, attribute)
        bloc.is_a?(Proc) ? instance_eval(&bloc) : object.send(attribute)
    end

    def save(attribute, result, bloc)
        result[attribute] = value(bloc, attribute)
    end
end
