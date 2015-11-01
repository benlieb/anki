require "spec_helper"
  
RSpec.describe OS do
  it "detects windows" do
    ['cygwin', 'mswin', 'mingw', 'bccwin', 'wince', 'emx'].each do |type|
      stub_const("RUBY_PLATFORM", type)
      expect(OS.windows?).to eq(true)
    end
  end
  it "detects mac" do
    stub_const("RUBY_PLATFORM", 'darwin')
    expect(OS.mac?).to eq(true)
  end
  it "detects linux" do
    stub_const("RUBY_PLATFORM", 'anythinggoes')
    expect(OS.linux?).to eq(true)
  end
end

