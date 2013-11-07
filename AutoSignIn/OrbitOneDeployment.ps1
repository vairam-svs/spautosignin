Add-PSSnapin "Microsoft.SharePoint.PowerShell"
cls

function Get-LocalSPFarm()
{
    return [Microsoft.SharePoint.Administration.SPFarm]::Local
}

function WaitForRemoveSPSolutionJobToComplete([string]$solutionName)
{
    $farm = Get-LocalSPFarm
    while (($farm.Solutions | Where-Object {$_.Name.ToLower().Trim() -eq "orbitone.sharepoint.claims.signin.wsp"}).Count -gt 0)
    {
          Write-Host "Solution '$solutionName' is not removed yet."
          Sleep 1
   }
   return $true;
}

function WaitForSPSolutionJobToComplete([string]$solutionName)
{
    $solution = Get-SPSolution -Identity $solutionName -ErrorAction SilentlyContinue
            $jobStatus = $solution.JobStatus
             
            # If the timer job succeeded then proceed
            if ($jobStatus -eq [Microsoft.SharePoint.Administration.SPRunningJobStatus]::Succeeded)
            {
                Write-Host "Solution '$solutionName' timer job suceeded"
                return $true
            }
             
            # If the timer job failed or was aborted then fail
            if ($jobStatus -eq [Microsoft.SharePoint.Administration.SPRunningJobStatus]::Aborted -or
                $jobStatus -eq [Microsoft.SharePoint.Administration.SPRunningJobStatus]::Failed)
            {
                Write-Host "Solution '$solutionName' has timer job status '$jobStatus'."
                return $false
            }
             
            # Otherwise wait for the timer job to finish
            Write-Host -NoNewLine "."
            Sleep 1

    if ($solution)
    {
        if ($solution.JobExists)
        {
            Write-Host -NoNewLine "Waiting for timer job to complete for solution '$solutionName'."
        }
        # Check if there is a timer job still associated with this solution and wait until it has finished
        while ($solution.JobExists)
        {
            $jobStatus = $solution.JobStatus
             
            # If the timer job succeeded then proceed
            if ($jobStatus -eq [Microsoft.SharePoint.Administration.SPRunningJobStatus]::Succeeded)
            {
                Write-Host "Solution '$solutionName' timer job suceeded"
                return $true
            }
             
            # If the timer job failed or was aborted then fail
            if ($jobStatus -eq [Microsoft.SharePoint.Administration.SPRunningJobStatus]::Aborted -or
                $jobStatus -eq [Microsoft.SharePoint.Administration.SPRunningJobStatus]::Failed)
            {
                Write-Host "Solution '$solutionName' has timer job status '$jobStatus'."
                return $false
            }
             
            # Otherwise wait for the timer job to finish
            Write-Host -NoNewLine "."
            Sleep 1
        }
         
        # Write a new line to the end of the '.....'
        Write-Host
    }
     
    return $true
}

#this or use update-solution 
UnInstall-SPSolution -Identity OrbitOne.SharePoint.Claims.SignIn.wsp 
if (WaitForSPSolutionJobToComplete("OrbitOne.SharePoint.Claims.SignIn.wsp")) { Remove-SPSolution -Identity OrbitOne.SharePoint.Claims.SignIn.wsp }
if (WaitForRemoveSPSolutionJobToComplete("OrbitOne.SharePoint.Claims.SignIn.wsp")) { Add-SPSolution "[filelocation]\OrbitOne.SharePoint.Claims.SignIn.wsp"}
Install-SPSolution -GACDeployment -CompatibilityLevel 15 -Identity OrbitOne.SharePoint.Claims.SignIn.wsp 

#Update-SPSolution -Identity OrbitOne.SharePoint.Claims.SignIn.wsp -LiteralPath "[filelocation]\OrbitOne.SharePoint.Claims.SignIn.wsp" -GACDeployment
