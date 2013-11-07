Add-PSSnapin "Microsoft.SharePoint.PowerShell"
cls
Get-SPSolution -Identity OrbitOne.SharePoint.Claims.SignIn.wsp

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
   return true;
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

#beginning of 
if (WaitForSPSolutionJobToComplete("OrbitOne.SharePoint.Claims.SignIn.wsp")) 
{
    Add-PSSnapin ClaimsSignInAdmin

    $config = Get-SPSignInConfiguration -webapplication "http://[mysitewebapproot]/"
    $config.ProviderMappings

    #/remove all configurations
    $config.ProviderMappings.Clear()
    $config.Update()

    #add all configurations
    #insert the granular - specific address or CIDR range with the smallest octet range first
    $config.ProviderMappings.Add("198.238.108.161","Windows Authentication")
    #$config.ProviderMappings.Add("198.238.118.57","Forms Authentication")

    #example range of values CIDR.
    #url to generate CIDR using your IP address
    #http://www.subnet-calculator.com/cidr.php

    #$config.ProviderMappings.Add("198.238.108.0/32","Windows Authentication")
    #$config.ProviderMappings.Add("198.238.118.0/32","Windows Authentication")

    #$config.ProviderMappings.Add("198.239.76.64/26","Windows Authentication")
    #$config.ProviderMappings.Add("198.238.118.0/26","Forms Authentication")

    #$config.ProviderMappings.Add("198.238.108.0/32","Forms Authentication")
    #$config.ProviderMappings.Add("198.238.118.0/32","Windows Authentication")

    #$config.ProviderMappings.Add("198.238.0.0/32","Forms Authentication")
    $config.Update()

}
