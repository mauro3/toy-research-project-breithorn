## General utility functions
using LibGit2, Dates

"""
    make_sha_filename(basename, ext)

Generate a filename
- pre-pending current date and time
- using the SHA hash of the current Git HEAD commit, a "-dirty" for
repos with uncommitted changes and the provided basename and extension.

Parameters:
- basename: The base part of the filename.
- ext: The extension part of the filename.

Returns:
A string that follows the format: `YYYMMDDTHH:MM-basename-short_hash[-dirty].ext`

Note:
The equivalent bash command to get the SHA hash is: `git rev-parse --short=10 HEAD`

Example:
If the current Git HEAD commit SHA hash (shortened) is 'a1b2c3d4e5', and there are no uncommitted changes, the
return value for `make_sha_filename("myfile", ".txt")` will be `myfile-a1b2c3d4e5.txt`.
If there are uncommitted changes, the return value will be `myfile-a1b2c3d4e5-dirty.txt`.
"""
function make_sha_filename(basename, ext)
    # Open the git-repository in the current directory
    repo = LibGit2.GitRepoExt(".")

    # Get the object ID of the HEAD commit
    head_commit_id = LibGit2.head_oid(repo)
    # Convert the object ID to a hexadecimal string and take the first 10 characters
    short_hash = string(head_commit_id)[1:10]

    # check if there are uncommitted changes
    if LibGit2.isdirty(repo)
        postfix = short_hash * "-dirty"
    else
        postfix = short_hash
    end

    return string(now())[1:end-7] * "-" * basename * "-" * postfix * ext
end
