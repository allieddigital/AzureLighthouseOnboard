param name string
param subnetRef string

@allowed([
  'Production'
  'Development'
  'Test'
])
param environment string

@description('Specify an ISO 8601 formatted date when this VM entered service. Example: 2021-07-14')
param created string

@description('Specify a fully qualified username (usually looks like an email address). Example: jdoe@nandps.onmicrosoft.com')
param requestor string

@secure()
param adminPassword string

param location string = 'westus2'
param networkInterfaceName string = name

param virtualMachineComputerName string = name
param osDiskType string = 'Premium_LRS'
param virtualMachineSize string = 'Standard_B2ms'
param adminUsername string = 'nandadmin'
param patchMode string = 'AutomaticByOS'
param enableHotpatching bool = false
param vnetName string
param subnetName string

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: '${vnetName}/${subnetName}'
}

@allowed([
  '1'
  '2'
  '3'
  ''
])
param zone string = ''

param imageReference object = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2019-datacenter-smalldisk-g2'
  version: 'latest'
}

resource networkInterfaceName_resource 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
  tags: {
    Environment: environment
    Created: created
    Requestor: requestor
  }
  dependsOn: []
}

resource virtualMachineName_resource 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: imageReference
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceName_resource.id
        }
      ]
    }
    osProfile: {
      computerName: virtualMachineComputerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          enableHotpatching: enableHotpatching
          patchMode: patchMode
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
  tags: {
    Environment: 'Production'
    Created: '2021-07-14'
    CreatedBy: 'jgrote@allieddigital.net'
  }
  zones: zone != '' ? [
    zone
  ] : null
}

output adminUsername string = adminUsername
