require 'spec_helper'


RSpec.describe Nesting do
  describe ".of" do
    it "raises an error on a non-module or a non-class argument" do
      expect { Nesting.of(123) }.to raise_error(TypeError)
    end

    it "doesn't raise error on an instance of Module" do
      expect { Nesting.of(Module.new).not_to raise_error(TypeError) }
    end

    it "doesn't raise error on an instance of Class" do
      expect { Nesting.of(Class.new).not_to raise_error(TypeError) }
    end

    it "detects nesting of BasicObject" do
      expect(Nesting.of(BasicObject)).to eq(1)
    end

    it "detects nesting of Object" do
      expect(Nesting.of(Object)).to eq(0)
    end

    it "detects nesting of a top-level class" do
      class ::TopLevelClass1; end
      expect(Nesting.of(TopLevelClass1)).to eq(1)
    end

    it "detects nesting of a top-level module" do
      module ::TopLevelModule1; end
      expect(Nesting.of(TopLevelModule1)).to eq(1)
    end

    it "returns -1 if a class is anonymous" do
      expect(Nesting.of(Class.new)).to eq(-1)
    end

    it "returns -1 if a module is anonymous" do
      expect(Nesting.of(Module.new)).to eq(-1)
    end

    it "detects nesting of a nested class" do
      class A1
        class B1; end
      end

      expect(Nesting.of(A1)).to eq(1)
      expect(Nesting.of(A1::B1)).to eq(2)
    end

    it "detects nesting of a nested module" do
      module A2
        module B2; end
      end

      expect(Nesting.of(A2)).to eq(1)
      expect(Nesting.of(A2::B2)).to eq(2)
    end

    it "detects mixed module/class nesting" do
      module A3
        class B3
          module C3; end
        end
      end

      expect(Nesting.of(A3)).to eq(1)
      expect(Nesting.of(A3::B3)).to eq(2)
      expect(Nesting.of(A3::B3::C3)).to eq(3)
    end

    it "detects nesting of a nested module defined via the shortcut" do
      module A4; end
      module A4::B4; end

      expect(Nesting.of(A4)).to eq(1)
      expect(Nesting.of(A4::B4)).to eq(2)
    end

    it "detects nesting of the class whose superclass is BasicObject" do
      class A5 < BasicObject; end
      expect(Nesting.of(A5)).to eq(1)
    end

    it "detects nesting of the nested class whose superclass is BasicObject" do
      class A6; end
      class A6::B6 < BasicObject; end

      expect(Nesting.of(A6)).to eq(1)
      expect(Nesting.of(A6::B6)).to eq(2)
    end

    it "detects nesting of a module depending on the context" do
      $expect = method(:expect)
      $eq = method(:eq)

      module A7
        module B7
          module C7
            $expect.(Nesting.of(B7)).to $eq.(2)
            $expect.(Nesting.of(C7)).to $eq.(3)
          end
          $expect.(Nesting.of(A7)).to $eq.(1)
          $expect.(Nesting.of(B7)).to $eq.(2)
        end

        $expect.(Nesting.of(A7)).to $eq.(1)
        $expect.(Nesting.of(B7)).to $eq.(2)
        $expect.(Nesting.of(B7::C7)).to $eq.(3)
      end
    end
  end

  describe ".parents" do
    it "raises an error on a non-module or a non-class argument" do
      expect { Nesting.parents(123) }.to raise_error(TypeError)
    end

    it "doesn't raise error on an instance of Module" do
      expect { Nesting.parents(Module.new).not_to raise_error(TypeError) }
    end

    it "doesn't raise error on an instance of Class" do
      expect { Nesting.parents(Class.new).not_to raise_error(TypeError) }
    end

    it "detects parents of BasicObject" do
      expect(Nesting.parents(BasicObject)).to eq([Object])
    end

    it "detects parents of Object" do
      expect(Nesting.parents(Object)).to eq(nil)
    end

    it "detects parents of a top-level class" do
      class ::TopLevelClass2; end
      expect(Nesting.parents(TopLevelClass2)).to eq([Object])
    end

    it "detects parents of a top-level module" do
      module ::TopLevelModule2; end
      expect(Nesting.parents(TopLevelModule2)).to eq([Object])
    end

    it "returns nil if a class is anonymous" do
      expect(Nesting.parents(Class.new)).to eq(nil)
    end

    it "returns nil if a module is anonymous" do
      expect(Nesting.parents(Module.new)).to eq(nil)
    end

    it "detects parents of a nested class" do
      class A1
        class B1; end
      end

      expect(Nesting.parents(A1)).to eq([Object])
      expect(Nesting.parents(A1::B1)).to eq([A1, Object])
    end

    it "detects parents of a nested module" do
      module A2
        module B2; end
      end

      expect(Nesting.parents(A2)).to eq([Object])
      expect(Nesting.parents(A2::B2)).to eq([A2, Object])
    end

    it "detects mixed module/class parents" do
      module A3
        class B3
          module C3
            class D3; end
          end
        end
      end

      expect(Nesting.parents(A3)).to eq([Object])
      expect(Nesting.parents(A3::B3)).to eq([A3, Object])
      expect(Nesting.parents(A3::B3::C3)).to eq([A3::B3, A3, Object])
    end

    it "detects parents of a nested module defined via the shortcut" do
      module A4; end
      module A4::B4; end

      expect(Nesting.parents(A4)).to eq([Object])
      expect(Nesting.parents(A4::B4)).to eq([A4, Object])
    end

    it "detects parents of the class whose superclass is BasicObject" do
      class A5 < BasicObject; end
      expect(Nesting.parents(A5)).to eq([Object])
    end

    it "detects parents of the nested class whose superclass is BasicObject" do
      class A6; end
      class A6::B6 < BasicObject; end

      expect(Nesting.parents(A6)).to eq([Object])
      expect(Nesting.parents(A6::B6)).to eq([A6, Object])
    end

    it "detects parents of a module depending on the context" do
      $expect = method(:expect)
      $eq = method(:eq)

      module A7
        module B7
          module C7
            $expect.(Nesting.parents(A7)).to $eq.([Object])
            $expect.(Nesting.parents(B7)).to $eq.([A7, Object])
            $expect.(Nesting.parents(C7)).to $eq.([A7::B7, A7, Object])
          end

          $expect.(Nesting.parents(A7)).to $eq.([Object])
          $expect.(Nesting.parents(B7)).to $eq.([A7, Object])
          $expect.(Nesting.parents(C7)).to $eq.([A7::B7, A7, Object])
        end

        $expect.(Nesting.parents(A7)).to $eq.([Object])
        $expect.(Nesting.parents(B7)).to $eq.([A7, Object])
        $expect.(Nesting.parents(B7::C7)).to $eq.([A7::B7, A7, Object])
      end
    end
  end
end
