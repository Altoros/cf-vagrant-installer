execute "alias installed ruby versions to match .ruby-version files" do
  Array(node['rbenv-alias']['user_rubies']).each do |ruby|
    versions_dir = "/home/#{ruby['user']}/.rbenv/versions"
    command "ln -sf #{versions_dir}/#{ruby['installed']} #{versions_dir}/#{ruby['alias']}"
  end
end
