# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dia}
  s.version = "2.0.0.pre"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Robert Gleeson"]
  s.date = %q{2010-07-16}
  s.description = %q{Through the use of technology found on Apple's Leopard and Snow Leopard operating systems, Dia can create dynamic and robust sandbox environments for applications and for blocks of ruby code. The Ruby API was designed to be simple, and a joy to use. I hope you feel the same way :-)}
  s.email = %q{rob@flowof.info}
  s.files = [".yardopts", "COPYING", "README.mkd", "dia.gemspec", "lib/dia.rb", "lib/dia/exceptions.rb", "lib/dia/functions.rb", "lib/dia/profiles.rb", "lib/dia/ruby_block.rb", "lib/dia/shared_features.rb", "test/setup.rb", "test/suite/lib/dia/ruby_block.rb", "test/suite/lib/dia/shared_features.rb"]
  s.has_rdoc = %q{yard}
  s.post_install_message = %q{  -------------------------------------------------------------------- 
  Dia (2.0.0.pre)
  
  Thanks for installing Dia, 2.0.0.pre! 

  >=2.0.0 releases include public API changes that are not backward
  compatiable with older releases. Be sure to check the docs!
 
  [Github]        http://github.com/robgleeson/dia
  [Documentation] http://yardoc.org/robgleeson-dia/
  --------------------------------------------------------------------  
}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Through the use of technology found on Apple's Leopard and Snow Leopard operating systems, Dia can create dynamic and robust sandbox environments for applications and for blocks of ruby code. The Ruby API was designed to be simple, and a joy to use. I hope you feel the same way :-)}
  s.test_files = ["test/setup.rb", "test/suite/lib/dia/ruby_block.rb", "test/suite/lib/dia/shared_features.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi>, ["= 0.6.2"])
      s.add_development_dependency(%q<baretest>, [">= 0.2.4"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<ffi>, ["= 0.6.2"])
      s.add_dependency(%q<baretest>, [">= 0.2.4"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<ffi>, ["= 0.6.2"])
    s.add_dependency(%q<baretest>, [">= 0.2.4"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
