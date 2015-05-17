# encoding: utf-8
include ProcMe

describe ProcMe do
  describe :call do
    let(:array){['test', 'x+y', 'fox']}
    
    describe 'side effects' do
      before{
        array.each(&call(sub!: ['x', 'y']))
      }
      subject{array}

      it{should == ['test', 'y+y', 'foy']}
    end

    describe 'return values' do
      subject{
        array.map(&call(sub: ['x', 'y']))
      }

      it{should == ['test', 'y+y', 'foy']}
    end
  end
end
