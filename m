From: Will Palmer <wmpalmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Permanently delete ("shred") files?
Date: Sat, 20 Jun 2009 16:43:19 +0100
Message-ID: <5b9751660906200843v3da0e733o229009a726ce9040@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hello, and sorry to ask a question which seems to me like something
which would probably already have been asked, but I didn't see any way
to search the mailing list archive, and manual skimming of it turned
up nothing. (in addition, that it wasn't listed in the FAQ or features
list made me think perhaps it needed to be asked)

Will there be / is there already, a feature to "delete a file
completely", meaning to remove a single file in such a way that it can
NOT be restored from checkpoints? Perhaps one which can fill existing
"versions" of a file with zeros, rather than leaving them as they are?

While for day-to-day use, being able to go back to five minutes ago
can often be a godsend, I presume there are more than the handful of
cases I can think of where "I actually want to leave no trace of that
file" would be true. Many situations crop up where one can normally
think "it's okay, I'll just remove the password before I hand it
over.", but a constantly-logging file-system would default to that not
being a safe bet. If nothing else, think of the occasional news
article about someone uncovering supposedly "redacted" sections of
word documents by viewing history on the file.

So I'd expect that it's clear to see it as a necessary feature for
"desktop use", but is it supported?
