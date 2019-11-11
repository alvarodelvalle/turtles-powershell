$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
Describe 'Convert-Customers' {
    BeforeAll {
        Mock Test-Path { $true }
    }

    Context 'Given Hashtable count is 2' {
        Mock Import-Csv {
            [PSCustomObject]@{
                Name = 'Arletha Tunison'
                Age  = 35
            }
        }

        It 'Outputs object @{Tunison, Arletha, 35}' {
            $hash = @{
                'Last Name'  = 'Tunison'
                'First Name' = 'Arletha'
                Age          = '35'
            }
            $PsObject = New-Object PsObject -Property $hash | Select-Object 'Last Name', 'First Name', 'Middle Initial', Age
            Convert-Customers -Path TestDrive:\import.csv | Should -MatchExactly $PsObject
        }
    }

    Context 'Given Hashtable count is 3' {
        It 'Outputs object @{Olivares, Brady, 44} when a prefix exists' {
            Mock Import-Csv {
                [PSCustomObject]@{
                    Name = 'Mr. Brady Olivares'
                    Age  = 44
                }
            }
            $hash = @{
                'Last Name'  = 'Olivares'
                'First Name' = 'Brady'
                Age          = 44
            }
            $PsObject = New-Object PsObject -Property $hash | Select-Object 'Last Name', 'First Name', 'Middle Initial', Age
            Convert-Customers -Path TestDrive:\import.csv | Should -MatchExactly $PsObject
        }

        It 'Outputs object @{Nielson, Christabel, E, 48} when a middle name exists' {
            Mock Import-Csv {
                [PSCustomObject]@{
                    Name = 'Christabel Emmalyn Nielson'
                    Age  = 48
                }
            }
            $hash = @{
                'Last Name'      = 'Nielson'
                'First Name'     = 'Christabel'
                'Middle Initial' = 'E'
                Age              = 48
            }
            $PsObject = New-Object PsObject -Property $hash | Select-Object 'Last Name', 'First Name', 'Middle Initial', Age
            Convert-Customers -Path TestDrive:\import.csv | Should -MatchExactly $PsObject
        }

        It 'Outputs object @{Lawless, Fe, K, 31} when a middle initial exists' {
            Mock Import-Csv {
                [PSCustomObject]@{
                    Name = 'Fe K. Lawless'
                    Age  = 31
                }
            }
            $hash = @{
                'Last Name'      = 'Lawless'
                'First Name'     = 'Fe'
                'Middle Initial' = 'K'
                Age              = 31
            }
            $PsObject = New-Object PsObject -Property $hash | Select-Object 'Last Name', 'First Name', 'Middle Initial', Age
            Convert-Customers -Path TestDrive:\import.csv | Should -MatchExactly $PsObject
        }
    }

    Context 'Given Hashtable count is 4' {
        It 'Outputs object @{Valle, Rachel, L, 35} when a prefix and middle name exists' {
            Mock Import-Csv {
                [PSCustomObject]@{
                    Name = 'Dr. Rachel Lisa Valle'
                    Age  = '35'
                }
            }
            $hash = @{
                'Last Name'      = 'Valle'
                'First Name'     = 'Rachel'
                'Middle Initial' = 'L'
                Age              = '35'
            }
            $PsObject = New-Object PsObject -Property $hash | Select-Object 'Last Name', 'First Name', 'Middle Initial', Age
            Convert-Customers -Path TestDrive:\import.csv | Should -MatchExactly $PsObject
        }

        It 'Outputs object @{Valor, Gabriel, A, 20} when a prfix and middle initial exists' {
            Mock Import-Csv {
                [PSCustomObject]@{
                    Name = 'Mr. Gabriel A. Valor'
                    Age  = 20
                }
            }
            $hash = @{
                'Last Name'      = 'Valor'
                'First Name'     = 'Gabriel'
                'Middle Initial' = 'A'
                Age              = 20
            }
            $PsObject = New-Object PsObject -Property $hash | Select-Object 'Last Name', 'First Name', 'Middle Initial', Age
            Convert-Customers -Path TestDrive:\import.csv | Should -MatchExactly $PsObject
        }
    }

    Context 'Given valid -Path parameter' {
        It 'Should give result if -Path is a valid file path' {
            Mock Import-Csv {
                [PSCustomObject]@{
                    Name = 'Dr. Rachel Lisa Valle'
                    Age  = '35'
                }
            }
            { Convert-Customers -Path TestDrive:\import.csv } | Should Not Throw
        }
    }

    Context 'Given invalid -Path parameter' {
        It 'Should give an invalid file path and throw error' {
            Mock Test-Path { $false }
            { Convert-Customers -Path TestDrive:\import.csv } | Should Throw 'Could not find file'
        }
    }

    Context 'Given an empty csv file' {
        Mock Import-Csv {
            $null
        }
        It 'Should do xxxxxx' {
            $y = Convert-Customers -Path TestDrive:\import.csv
            $y | Should -MatchExactly ''
        }
    }
}
