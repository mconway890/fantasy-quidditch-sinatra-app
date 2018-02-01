class TeamController < ApplicationController
    
    get '/teams' do
        @teams = Team.all
        if Helpers.logged_in?(session)
          erb :'teams/teams_index'
        else
          redirect to '/login'
        end
    end
    
    get '/teams/new' do
        if Helpers.logged_in?(session)
          erb :'/teams/create_team'
        else
          redirect to '/login'
        end
    end
    
    post '/teams' do
        @team = Team.create(name: params[:name],chaser: params[:chaser],beater: params[:beater],keeper: params[:keeper],seeker: params[:seeker], user_id: session[:user_id])
        @team.user = current_user
        @team.save
        #if team.name != "" #&& team.chaser != "" && team.beater != "" && team.keeper != "" && team.seeker != ""
          #redirect to "teams/#{team.id}"
        #else
          #redirect to '/teams/new'
        #end
        redirect '/teams'
    end
    
    get '/teams/:id' do
      if Helpers.logged_in?(session)
        @team = Team.find_by(id: params[:id])
        erb :'teams/show_team'
      else
        redirect to '/login'
      end
    end

  
  get '/teams/:id/edit' do 
      if Helpers.logged_in?(session) 
        @team = Team.find_by(id: params[:id])
          if Helpers.current_user(session).id == @team.user_id
            erb :'teams/edit_team'
          else
            redirect '/login'
          end
      end
  end
  
  patch '/teams/:id' do
    @team = Team.find_by(id: params[:id])
    if Helpers.current_user(session) == @team.user
    @team.update(name: params[:name],chaser: params[:chaser],beater: params[:beater],keeper: params[:keeper],seeker: params[:seeker])
    @team.save
    #if team.name != "" && team.chaser != "" && team.beater != "" && team.keeper != "" && team.seeker != ""
      redirect to "teams/#{team.id}"
    else
      erb :'/teams/team_error'
    end
  end
  
  delete '/teams/:id/delete' do
    @team = Team.find_by(id: params[:id])
    if Helpers.current_user(session) == @team.user
          @team.delete
          redirect '/teams'
    else
       erb :'/teams/team_error'
    end
  end

end