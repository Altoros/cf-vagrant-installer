packages = %w(
  openjdk-6-jdk
  maven
)

packages.each do |package_name|
  package package_name do
    action :install
  end
end
