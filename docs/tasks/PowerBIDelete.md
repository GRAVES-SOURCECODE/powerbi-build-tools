# Task: Power BI Delete

## Overview

Deletes a workspace, dataset, dataflow, or report.

## Schema

```
- task: PowerBIDelete@1
  displayName: {string}
  inputs:
    connection: {string}
    type: {pickList}
    workspace: {string}
    name: {string}
```

## Inputs

| Name | Label | Required | Type | Description
|------|-------|----------|------|------------
| Connection | Power BI connection | True | string | The service connection to Power BI.
| Type | Type | True | pickList | <ul><li>Dataflow</li><li>Dataset</li><li>Report</li><li>Workspace</li></ul>
| Workspace | Workspace | False | string | The ID or name of the workspace. If not specified, your personal workspace will be used.
| Name | Name | True | string | The ID or name of the object.
