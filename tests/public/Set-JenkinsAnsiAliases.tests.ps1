Describe "Set-JenkinsAnsiAliases"{
    
    It "Should not throw"{
        {Set-JenkinsAnsiAliases} | Should not throw
    }

    It "Should work with basic error"{
        {Write-Error "Hello" -ErrorAction SilentlyContinue} | Should not throw
    }
    
    It "Should work with complex error"{
        {Write-Error "Hello" -Category CloseError -CategoryActivity 'Boop' -CategoryReason 'Reasons' -CategoryTargetName 'Target' -CategoryTargetType 'TargetType' -ErrorId 23 -TargetObject "test" -RecommendedAction "test" -ErrorAction SilentlyContinue} | Should not throw
    }

    It "Should work with basic verbose"{
        {Write-Verbose "Hello"} | Should not throw
    }

    It "Should work with basic info"{
        {Write-Info "Hello"} | Should not throw
    }

    It "Should work with complex info"{
        {Write-Info "Hello" -Tags "test"} | Should not throw
    }

    It "Should work with basic Warning"{
        {Write-Warning "Hello" -WarningAction SilentlyContinue} | Should not throw
    }

    It "Should work with basic Debug"{
        {Write-Debug "Hello"} | Should not throw
    }
}