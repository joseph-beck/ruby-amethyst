Token = Struct.new(:type, :value)

class Tokenizer
    TOKEN_TYPES = [
        [:def,          /\bfunc\b/],
        [:end,          /\bend\b/],
        [:identifier,   /\b[a-zA-Z]+\b/],
        [:integer,      /\b[0-9]+\b/],
        [:oparen,       /\(/],
        [:cparen,       /\)/],
        [:comma,        /,/],
    ]

    def initialize(code)
        @code = code
    end

    def tokenize
        tokens = []

        until @code.empty?
            tokens << tokenize_one_token
            @code = @code.strip
        end

        return tokens
    end

    def tokenize_one_token
        TOKEN_TYPES.each do |type, re|
            re = /\A(#{re})/
            if @code =~ re
                value = $1
                @code = @code[value.length..-1]
                return Token.new(type, value)
            end
        end

        raise RuntimeError.new("Couldn't match token on the #{@code.inspect}")
    end
end