From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Permanently delete ("shred") files?
Date: Sun, 21 Jun 2009 20:39:31 +0900 (JST)
Message-ID: <20090621.203931.75201431.ryusuke@osrg.net>
References: <5b9751660906200843v3da0e733o229009a726ce9040@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <5b9751660906200843v3da0e733o229009a726ce9040-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, wmpalmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi!
On Sat, 20 Jun 2009 16:43:19 +0100, Will Palmer wrote:
> Hello, and sorry to ask a question which seems to me like something
> which would probably already have been asked, but I didn't see any way
> to search the mailing list archive, and manual skimming of it turned
> up nothing. (in addition, that it wasn't listed in the FAQ or features
> list made me think perhaps it needed to be asked)

Use search box of the top page or 

 http://www.nilfs.org/cgi-bin/namazu.cgi

I think you can also use "site" option of web search engines, for
instance:

 <keyword> site:www.nilfs.org/pipermail/users

Anyway, questions are welcome.

> Will there be / is there already, a feature to "delete a file
> completely", meaning to remove a single file in such a way that it can
> NOT be restored from checkpoints? Perhaps one which can fill existing
> "versions" of a file with zeros, rather than leaving them as they are?
>
> While for day-to-day use, being able to go back to five minutes ago
> can often be a godsend, I presume there are more than the handful of
> cases I can think of where "I actually want to leave no trace of that
> file" would be true. Many situations crop up where one can normally
> think "it's okay, I'll just remove the password before I hand it
> over.", but a constantly-logging file-system would default to that not
> being a safe bet. If nothing else, think of the occasional news
> article about someone uncovering supposedly "redacted" sections of
> word documents by viewing history on the file.

I agree. The shred file feature is worthy of consideration.

Since the current nilfs forbids to overwrite any past logs, it would
be realized utilizing GC API.  I think it's feasible and sounds
fascinating.

One problem is how we think about identity of the file.

Usually, applications like editor transiently create backup or
temporary files with different names and may change inode number of
the file in process of "save file" operation.  These intermediate
files may be snapshotted in checkpoints.

Nilfs internally identify files with inode numbers like regular file
systems, but it is not sufficent for this end.  A pathname based
matching method will be required.

And, for the temp file problem, the shred command for nilfs has to
know the pattern of the temp file name for every application.  It's
still not infeasible, but the tool ought to have much work to do than
we think.
 
> So I'd expect that it's clear to see it as a necessary feature for
> "desktop use", but is it supported?

Yes, I agree the importance of this feature.

I've added this to the todo items in the site.

Cheers,
Ryusuke Konishi
