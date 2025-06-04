$url = "git@github.com:kataarosina/devopsCourse.git"
$repoName = "devopsCourse"

try {
    Write-Host "Cloning repository.."
    git clone $url $repoName
    Set-Location -Path $repoName
    $desc = git describe --tags
    Write-Host "Current tag description: $desc"

    if ($desc.Contains("-")) {
        Write-Host "New commits found. Bumping patch version..."
        $baseTag = $desc.Split("-")[0]
        $parts = $baseTag.Split(".")
        $major = [int]$parts[0]
        $minor = [int]$parts[1]
        $patch = [int]$parts[2]
        $patch += 1
        $newTag = "$major.$minor.$patch"

        git tag -a $newTag -m "Auto-generated patch tag $newTag"
        git push origin $newTag
        Write-Host "New tag created and pushed: $newTag"
    } else {
        Write-Host "No changes. Latest tag already points to HEAD."
    }

    Set-Location ..
    Remove-Item -Recurse -Force $repoName
    Write-Host "Local copy of the repository deleted."

} catch {
    Write-Error "Error: $_"
}

Read-Host -Prompt "Press Enter to exit"