from buildbot.util import giturlparse


def codebaseGenerator(chdict):
    """ Generate a codebase description.

    The codebase generator takes information about a change, like repository,
    branch, and revision, and creates a predictable string describing the code.
    This is used to decide upon the builder for a change and also to tie a fork
    repository back to its parent for merge requests.
    """

    giturl = giturlparse(chdict['repository'])
    return "{}:{}/{}".format(giturl.domain, giturl.owner, giturl.repo)
