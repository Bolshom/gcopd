tss = function(vector){
  total_seconds = length(vector)
  ma30s = zoo::rollmean(vector, 30)
  mean_fourth = mean(ma30s^4)
  
  return(round(total_seconds*sqrt(mean_fourth)/36))
}