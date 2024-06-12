## General utility functions
using LibGit2, Dates, Downloads
using JLSO, ZipFile

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

"""
    download_file(url, destination_file)

Download a file, if it has not been downloaded already.

For password protected access use the `~/.netrc` file to store passwords, see
https://everything.curl.dev/usingcurl/netrc .

For downloading files on the local file system prefix their path with `file://`
as you would to see them in a browser.

# Input
- url -- url for download
- destination_file -- path (directory + file) where to store it
"""
function download_file(url, destination_file)
    # make sure the directory exists
    mkpath(splitdir(destination_file)[1])

    if isfile(destination_file)
        # do nothing
        println("Already downloaded $destination_file")
    else
        # download
        print("Downloading $destination_file ... ")
        Downloads.download(url, destination_file)
        println("done.")
    end
    return
end

"""
    unzip_one_file(zipfile, filename, destination_file)

Unzip one file from a zip-archive.

Inputs:
- `zipfile`: path to zip-file
- `filename`: name of file within the zip-archive to unzip, including any paths within the zipfile
- 'destination_file`: path+file where to place the file
"""
function unzip_one_file(zipfile, filename, destination_file)
    # make sure the directory exists
    mkpath(splitdir(destination_file)[1])

    r = ZipFile.Reader(zipfile)
    for f in r.files
        if f.name == filename
            write(destination_file, read(f, String))
        end
    end
    return nothing
end

"""
    run_cache(fn, args, cache_file; force=false)

Run a function or load its result from a cache file.  For long
running functions, this allows to cache its results.

NOTE: this assumes that you pass in the same args.  No checks regarding this are done.

Parameters:
- `fn`: The function to run if no cached result is available or if forced. The function should accept the elements of `args` as arguments.
- `args`: A tuple of arguments to pass to the function `fn`.
- `cache_file`: A string specifying the base path and filename (without file extension) for the cache file to store the function result.
- `force` (optional keyword argument): A boolean flag indicating whether to force re-run the function even if a cache file exists. Default is `false`.

Returns:
- The output of the function `fn`, either loaded from the cache file or computed by running the function.

Example usage:
```julia
function expensive_computation(x, y)
    sleep(5)  # Simulates a long-running computation
    return x + y
end

# Arguments for the function
args = (3, 4)

# Cache file base name
cache_file = "cache/expensive_computation_result"

# Run the function and cache its result
result = run_cache(expensive_computation, args, cache_file)

println("Result: ", result)
```
"""
function run_cache(fn, args, cache_file; force=false)
    out = if !isfile(cache_file*".jlso") || force
        out = fn(args...)
        JLSO.save(cache_file*".jlso", :out => out)
        out
    else
        JLSO.load(cache_file*".jlso")[:out]
    end
    return out
end
