module Nesting
  class << self
    def of(mod)
      if nonmodule?(mod)
        raise TypeError, 'mod is not a class or module'
      end

      level = 0

      # Special case Object as it's the namespace of all classes.
      return level if mod == Object

      level = if mod.name
                mod.name.split('::').count
              else
                -1 # Probably an anonymous module.
              end

      level
    end

    def parents(mod)
      if nonmodule?(mod)
        raise TypeError, 'mod is not a class or module'
      end

      parents = []

      return nil if mod == Object

      if mod.name
        mod.name.split('::')[0..-2].inject(Object) do |parent, child|
          const = parent.const_get(child)
          parents << const
          const
        end
        parents.reverse! << Object
      else
        parents = nil # Probably an anonymous module.
      end

      parents
    end

    private

    def nonmodule?(mod)
      !((mod.class == Module) ^ (mod.class == Class))
    end
  end
end
