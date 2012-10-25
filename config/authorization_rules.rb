# coding: UTF-8

authorization do
  role :siteadmin do
    has_permission_on [:users], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:stats], :to => [:index]
    has_permission_on [:session_caches], :to => [:authorize]
    has_permission_on [:dropbox], :to => [:index, :authorize]
  end

  role :admin do
    has_permission_on [:notes], :to => [:index, :show, :new, :create, :edit, :update, :destroy, :voice]
    has_permission_on [:evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:links], :to => [:new, :create, :edit, :update, :destroy, :show]
    has_permission_on [:uploads], :to => [:new, :create, :destroy, :show]
    has_permission_on [:archive], :to => [:download]
    has_permission_on [:search], :to => [:search, :typeahead]
  end

  role :account do
    has_permission_on [:account], :to => [:index, :edit, :update]
  end

  role :normal do
    has_permission_on [:notes, :evensongs, :composers, :genres, :periods, :languages], :to => [:index, :show]
    has_permission_on [:links], :to => [:show]
    has_permission_on [:uploads], :to => [:show]
    has_permission_on [:archive], :to => [:download]
    has_permission_on [:search], :to => [:search, :typeahead]
  end
end
