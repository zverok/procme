# encoding: utf-8
include ProcMe

describe ProcMe do
  let(:array){['Test', 'x+Y', 'fOxy']}

  describe :filter do
    subject{
      array.select(&fltr(length: 4))
    }

    it{should == ['Test', 'fOxy']}
  end

  describe :get do
    context 'when one value' do
      subject{array.map(&get(:length))}

      it{should == [4, 3, 4]}
    end

    context 'when several values' do
      subject{array.map(&get(:upcase, :downcase))}

      it{should == [['TEST', 'test'], ['X+Y', 'x+y'], ['FOXY', 'foxy']]}
    end
  end

  describe :set do
    class A
      attr_accessor :setme
    end

    let(:array){[A.new, A.new, A.new]}

    before{
      array.each(&set(setme: 'wtf'))
    }

    subject{array.map(&:setme)}

    it{should == ['wtf', 'wtf', 'wtf']}
  end
  
  describe :call do
    describe 'side effects' do
      before{
        array.each(&call(sub!: ['x', 'y']))
      }
      subject{array}

      it{should == ['Test', 'y+Y', 'fOyy']}
    end

    describe 'return values' do
      subject{
        array.map(&call(sub: ['x', 'y']))
      }

      it{should == ['Test', 'y+Y', 'fOyy']}
    end

    describe 'return values - multiple methods' do
      subject{
        array.map(&call(sub: ['x', 'y'], index: 'y'))
      }

      # each method performed on ORIGINAL object
      it{should == [['Test', nil], ['y+Y', nil], ['fOyy', 3]]}
    end

    describe 'no arguments' do
      subject{
        array.map(&call(:upcase, :'+' => '!'))
      }

      # each method performed on ORIGINAL object
      it{should == [['TEST', 'Test!'], ['X+Y', 'x+Y!'], ['FOXY', 'fOxy!']]}
    end
  end
end
