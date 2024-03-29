# Deployment variables 
$location = '<Location>'
$projectRg = '<Project Name>'

# Create the deployment Resouce Group
New-AzResourceGroup `
    -Location $location `
    -Name $projectRg

New-AzResourceGroupDeployment `
    -ResourceGroupName $projectRg `
    -Templatefile azuredeploy.json `
    -projectName '<Project Name>' `
    -storageSKU  'Standard_ZRS'

# Create the Template Spec
# Template Spec variables
$tempSpecsName = '<Template Specs Name>'
$tempSpecsRg = '<Template Specs Resource Group>'
$tempSpecsVer = '1.0'

# Create the resouce group
New-AzResourceGroup `
    -Location $location `
    -Name $tempSpecsRg

# Create the Template Spec
New-AzTemplateSpec `
    -Name $tempSpecsName `
    -Version $tempSpecsVer `
    -ResourceGroupName $tempSpecsRg `
    -Location $location `
    -TemplateFile .\azuredeploy.json

# Deploy with Teplate Spec
# Get the Template Specs ID
$templateSpecID = (Get-AzTemplateSpec -ResourceGroupName $tempSpecsRg -Name $tempSpecsName -Version $tempSpecsVer).Versions.Id

# Run the deployment
New-AzResourceGroupDeployment `
    -ResourceGroupName $projectRg `
    -TemplateSpecId $templateSpecID `
    -projectName '<Project Name>' `
    -storageSKU  'Standard_ZRS'


# Run the deployment with tags
New-AzResourceGroupDeployment `
    -ResourceGroupName $projectRg `
    -TemplateSpecId $templateSpecID `
    -projectName '<Project Name>' `
    -storageSKU  'Standard_ZRS' `
    -tags @{Environment = "Lab"}
