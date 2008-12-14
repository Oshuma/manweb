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

post '/' do
  @page_name = params[:page_name]
  output = %x/man #{@page_name} | col -b/
  # Doesn't catch stderr, so it will be an empty string if no man page was found.
  @page_text = output.empty? ? nil : output
  haml :page
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
      #header= TITLE
      %form{:action => '/', :method => 'post', :id => 'search-form'}
        %input{:name => 'page_name', :type => 'text', :value => "#{@page_name}"}
        %input{:type => 'submit', :value => 'Search'}
    #man-page
      = yield


@@ index
%p Enter the name of a manual page in the top right search box.


@@ page
- if @page_text
  %h1== Manual for '#{@page_name}'
  %pre= @page_text
- else
  %p== Could not find manual page for '<strong>#{@page_name}</strong>'.


@@ stylesheet
!main_color = #eee

body
  :background-color = !main_color
  :font
    :family "Helvetica", "Arial", sans-serif
  :margin 0
  :padding 0

#top-bar
  #header
    :float left
    :font-weight bold
    :padding-left 1em

  :background-color = !main_color
  :border-bottom 1px solid #000
  :line-height 1.5em
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
  :padding 45px 10px 10px 10px

  h1
    :font-size 20px
    :margin-top 0
    :text-align center

  pre
    :margin auto 4em
