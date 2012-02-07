require 'spec_helper'

module Emma
  describe Report do
    before(:all) do
      @report = Report.from File.expand_path("../../fixtures/coverage.xml", __FILE__)
    end

    it "has stats" do
      @report.stats.should == {
        :packages     => 624,
        :classes      => 5919,
        :methods      => 57688,
        :source_files => 3973,
        :source_lines => 265538,
      }
    end

    it "has packages" do
      @report.data.packages.size.should == 1
    end

    it "has source files" do
      @report.data.source_files.size.should == 1
    end

    it "has classes" do
      @report.data.classes.size.should == 1
    end

    it "has methods" do
      @report.data.methods.size.should == 7
    end

    it "knows the coverages of an element" do
      cov = @report.data.source_files.first.coverages

      cov.line.percent.should == 0
      cov.line.total.should == 58.0
      cov.line.covered.should == 0

      cov.method.percent.should == 0
      cov.method.total.should == 7.0
      cov.method.covered.should == 0

      cov.block.percent.should == 0
      cov.block.total.should == 325.0
      cov.block.covered.should == 0

      cov.klass.percent.should == 0
      cov.klass.total.should == 1.0
      cov.klass.covered.should == 0
    end
  end
end
