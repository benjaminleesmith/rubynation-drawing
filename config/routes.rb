PivotalTrackerDrawing::Application.routes.draw do
  resources :entries, only: [:create]
end
