DefNode = Struct.new(:name, :arg_names, :body)
IntegerNode = Struct.new(:value)
CallNode = Struct.new(:name, :arg_exprs)
VarRefNode = Struct.new(:value)

class Parser
    def initialize(tokens)
        @tokens = tokens
    end

    def parse
        parse_def
    end

    def parse_def
        consume(:def)

        name = consume(:identifier).value
        arg_names = parse_arg_names
        body = parse_expr

        consume(:end)

        DefNode.new(name, arg_names, body)
    end

    def parse_arg_names
        arg_names = []

        consume(:oparen)

        if peek(:identifier)
            arg_names << consume(:identifier).value

            while peek(:comma)
                consume(:comma)
                arg_names << consume(:identifier).value
            end
        end

        consume(:cparen)
        
        return arg_names
    end

    def parse_expr
        if peek(:integer)
            parse_integer
        elsif peek(:identifier) && peek(:oparen, 1)
            parse_call
        else
            parse_var_ref
        end
    end

    def parse_integer
        IntegerNode.new(consume(:integer).value.to_i)
    end

    def parse_call
        name = consume(:identifier).value
        arg_exprs = parse_args_exprs
    
        CallNode.new(name, arg_exprs)
    end

    def parse_args_exprs
        arg_exprs = []

        consume(:oparen)

        if !peek(:cparen)
            arg_exprs << parse_expr

            while peek(:comma)
                consume(:comma)
                arg_exprs << parse_expr
            end
        end

        consume(:cparen)
        
        return arg_exprs
    end

    def parse_var_ref
        VarRefNode.new(consume(:identifier).value)
    end

    def consume(expected_type)
        token = @tokens.shift

        if token.type == expected_type
            token
        else
            raise RuntimeError.new("Expected token type #{expected_type.inspect} but got #{token.type.inspect}")
        end
    end

    def peek(expected_type, offset=0)
        return @tokens.fetch(offset).type == expected_type
    end
end