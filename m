From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IOzone testing
Date: Sat, 26 Sep 2009 08:54:37 -0400
Message-ID: <debc30fc0909260554s21969638h280d9e6f89b7596e@mail.gmail.com>
References: <4ABE0553.3090502@att.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4ABE0553.3090502-fOdFMYwuEsI@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

On Sat, Sep 26, 2009 at 8:13 AM, Jeff Layton <laytonjb-fOdFMYwuEsI@public.gmane.org> wrote:
> Good morning,
>
> I'm running IOzone on a NILFS2 partition and it's running alot
> slower that I had expected. I'm pretty sure it's because of the
> checkpoints. I can change the protection_period to something
> very small (or zero). Would that improve the performance?
>
The protection period only affects how the cleaner daemon will clean
the old checkpoints, if 0 I guess it will just clean them up as soon
as it can but it won't stop creating them. You could, just for
benchmark purpose, kill nilfs_cleanerd which will stop checkpoint
related activities.

> In addition, is there a way to turn off checkpointing?
>
The whole filesystem is based on those checkpoint, the fact that it is
a log filesystem makes it so all writes are made at the end of the
device, and when a write is complete, a checkpoint is made.

> Thanks!
>
> Jeff
