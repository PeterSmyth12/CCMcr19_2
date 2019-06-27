$dir = "C:\Users\pfsmy\OneDrive\UoM\2019\Carpentry Conference\Powershell workshop\data_folder\"
#$dir = "C:\Users\Pete_local\OneDrive\UoM\2019\Carpentry Conference\Powershell workshop\data_folder\"

Set-Location $dir

# get a list of the month files
$list = get-childitem | Where-Object {$_.name -notmatch "all" -and $_.name.StartsWith('y')}

# Create and populate a dictionary from the list of files
$mydict = @{}
$list | ForEach-Object { $year = $_.name.Substring(1,4);
                         if ( $mydict.ContainsKey($year)) { $mydict[$year] = $mydict[$year] + $_.name }
                         else {$mydict.add($year, @($_.name))  }
                       }

$month_to_number = @{ Jan = '01'
                      Feb = '02'
                      Mar = '03'
                      Apr = '04'
                      May = '05'
                      Jun = '06'
                      Jul = '07'
                      Aug = '08'
                      Sep = '09'
                      Oct = '10'
                      Nov = '11'
                      Dec = '12' }

# Process all of the files in the dictionary to create file years

ForEach($key in $myDict.keys)  { write-host "New file for year $key" ;

                                 $year = $key ;
                                 $filename = 'y'+ $year + 'all.csv';
                               

                                 for ($i=0; $i -lt $mydict[$key].length; $i++) {
                                     
                                     $month = $month_to_number[$mydict[$key][$i].Substring(6,3)]

	                                 $file_content = Import-Csv $mydict[$key][$i] 
                                     $file_content | foreach-object {
                                                     if ($_.day.Length -eq 1) { $day = "0" + $_.day } else {$day = $_.day }
                                                     New-Object PSObject -prop @{Date = "$year-$month-$day";
                                                     year = $year;
                                                     month = $month;
                                                     day = $day;
                                                     min = $_.min ;
                                                     max = $_.max ;
                                                     hrs_sunshine = $_.hrs_sunshine } | select-object Date, year, month, day, min, max, hrs_sunshine 
                                                   } |  Export-csv $filename -Append -NoTypeInformation

                                  }                  
                              
                                 $x = Import-Csv $filename | Sort-object -property Date 
                                 $x | Export-csv $filename -NoTypeInformation 

                                 write-host "Close file for year $key"
                               }



# This as the final exercise to finish off the task

$dir = "C:\Users\pfsmy\OneDrive\UoM\2019\Carpentry Conference\Powershell workshop\data_folder\"
#$dir = "C:\Users\Pete_local\OneDrive\UoM\2019\Carpentry Conference\Powershell workshop\data_folder\"

Set-Location $dir

# get a list of the month files
$list = get-childitem | Where-Object {$_.name -match "all"}
#$list


# create the output file and add the header

$outfile = $dir + "allfiles.csv"

$list | sort-object | Select-Object name | ForEach-Object { Import-Csv $_.name |
                                                            Export-csv $outfile -Append -NoTypeInformation 
                                                          } 