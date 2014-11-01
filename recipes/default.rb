#
# Cookbook Name:: login_users
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

data_ids = data_bag('login_users')

data_ids.each do |id|
  u = Chef::EncryptedDataBagItem.load('login_users', id)

  group u["groups"] do
    action :create
  end

  user u['username'] do
    supports :managa_home => true
    uid u["uid"]
    gid u["groups"]
    home u['home']
    shell u['shell']
    password u['password']
  end

  directory "#{u['home']}/.ssh" do
    owner u['username']
    group u['groups']
    mode 0700
    action :create
    only_if "test -d #{u['home']}"
  end

  file "#{u['home']}/.ssh/authorized_keys" do
    owner u['username']
    group u['groups']
    mode 0601
    content u["ssh_keys"]
  end
end
