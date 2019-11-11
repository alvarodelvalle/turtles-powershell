function Convert-Customers {
    [cmdletbinding()]
    param (
        $Path
    )
    Begin {
        Write-Verbose -Message "[BEGIN  ] Function to convert csv file to table with expanded columns"
    }

    Process {
        try {
            $customers_data = Import-Csv -Path $Path
        }
        catch {
            Write-Error -Message $_.Exception.Message -ErrorAction Stop
        }
        $customers_table = @()
        foreach ($item in $customers_data) {
            $item_obj = $item.Name.Split(" ")
            $x = $item_obj.Count
            try {
                switch ($x) {
                    2 {
                        $hash = @{
                            "Last Name"  = $item_obj[1]
                            "First Name" = $item_obj[0]
                            Age          = $item.Age
                        }
                    }
                    3 {
                        $matches = $item_obj[0] -match '\w{2,3}\.'
                        if ($matches) {
                            $hash = @{
                                "Last Name"  = $item_obj[2]
                                "First Name" = $item_obj[1]
                                Age          = $item.Age
                            }
                        }
                        else {
                            $hash = @{
                                "Last Name"      = $item_obj[2]
                                "First Name"     = $item_obj[0]
                                "Middle Initial" = $item_obj[1].Substring(0, 1)
                                Age              = $item.Age
                            }
                        }
                    }
                    4 {
                        $hash = @{
                            "Last Name"      = $item_obj[3]
                            "First Name"     = $item_obj[1]
                            "Middle Initial" = $item_obj[2].Substring(0, 1)
                            Age              = $item.Age
                        }
                    }
                    default { Write-Verbose -Message "[Process] Could not find object count" }
                }
            }
            catch {
                Write-Error -Message $_.Exception.Message -ErrorAction Stop
            }
            $ps_object = new-object psobject -property $hash
            $customers_table += $ps_object
        }
        return $customers_table | Select-Object "Last Name", "First Name", "Middle Initial", Age
    }

    End {
        Write-Verbose -Message "[END] Completed converstion to table"
    }
}
