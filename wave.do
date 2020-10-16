view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 25ps -dutycycle 25 -starttime 0ps -endtime 10000ps sim:/system/Clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 10000ps sim:/system/Reset 
wave modify -driver freeze -pattern constant -value St1 -starttime 0ps -endtime 25ps Edit:/system/Reset 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 10000ps sim:/system/Run 
WaveCollapseAll -1
wave clipboard restore
