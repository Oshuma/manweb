# = ManWeb
# A simple Sinatra app to display manual pages.

%w{
  rubygems
  sinatra
  haml
}.each { |dep| require dep }

configure do
  TITLE = 'ManWeb: Manual Page Browser'
end


#
# == Actions
#

get '/' do
  haml :index
end

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end


#
# == Templates
#

use_in_file_templates!

__END__

@@ layout
!!!
%html
  %head
    %title= TITLE
    %link{:rel => 'stylesheet', :href => '/styles.css', :type => 'text/css'}
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html'}

  %body
    #top-bar
      %form{:action => '/search', :method => 'post'}
        %input{:name => 'page', :type => 'text'}
        %input{:type => 'submit', :value => 'Search'}
    #man-page
      = 500.times {haml_concat 'page contents'}
      = yield

@@ index


@@ stylesheet
body
  :background-color #f5f5f5
  :font
    :family "Helvetica", "Arial", sans-serif
  :margin 0
  :padding 0

#top-bar
  :background-color #f5f5f5
  :border-bottom 1px solid #000
  :padding-top 5px
  :padding-bottom 5px
  :position fixed
  :text-align right
  :width 100%

#man-page
  :background-color #fff
  :border 1px solid #000
  :margin auto
  :margin-bottom 10px
  :max-width 900px
  :padding 40px 10px 10px 10px
