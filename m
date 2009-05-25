From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Nilfs features
Date: Tue, 26 May 2009 08:20:51 +0900 (JST)
Message-ID: <20090526.082051.100027806.ryusuke@osrg.net>
References: <4A1A68E6.50905@0bits.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A1A68E6.50905-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org

Hi,
On Mon, 25 May 2009 13:46:14 +0400, Dave wrote:
> Hi,
> 
> I converted (backup/restore) my home directory onto nilfs2 to test it in 
> anger  (yes i know the caveats about it corrupting all my data, etc, but 
> i'm willing to restore when required).

What happened to you ?
Anyway, thanks for your interest in nilfs.
(yeah, I'm trying my best, but I keenly feel it's really tough to keep
the reliability of the filesystem.  so, please remember the caveat.)
 
> When restoring the data onto a nilfs2 filesystem there really is no 
> requirement to have the checkpointing running as you have a good copy 
> from your tar, cpio archive that you are restoring from.

Yes, definitely.

> So is there a way to temporarily suspend checkpointing with a
> command and then restart it after the restore has completed ? I
> think this would be useful also for when you want to have a
> 'privacy' mode (like firefox/mozilla) where you can suspend
> checkpointing, start some confidential work, email, browsing etc,
> and then restart checkpointing and roll back to the previous state.

Is your demand rollback feature or some kind of silent (or invalid by
default) checkpointing, or both ?

The checkpointing is essential for nilfs, every write on nilfs
requires creating a checkpoint by its nature.  But I think it's
possible to make them inaccessible by default.

Rollback is worth considering.  Yes, I agree.  it actually makes the
recovery of filesystem state smarter.

It even could be a first step toward realization of the remote
replication (as discussed before in this mailing list).

> In addition to this there doesn't seem to be a way to delete a range of 
> checkpoints. When i did my restore from my archive, i generated 700+ 
> useless checkpoints which i had to delete one by one (in a script). It 
> would be nice to have a 'rmcp 1-100' or 'rmcp -100' or 'rmcp 100-' to 
> delete a checkpoint range, a start to end.

Okay, I'll take in this in some form.

> Also it seems for home directories, a 5 second checkpointing seems 
> exessive. In 14hrs i have 10,000 checkpoints (even when seemingly idle 
> with mozilla page refreshes, dovecot index files updates  for email, etc).
>
> home:~$ uptime
>   13:35:09 up 14:29,  7 users,  load average: 0.85, 1.76, 2.07
> home:~$ lscp|tail
>                 10342  2009-05-25 13:34:31   cp    i       6698     323163
>                 10343  2009-05-25 13:34:36   cp    -       6761     323163
>                 10344  2009-05-25 13:34:41   cp    i       6702     323163
>                 10345  2009-05-25 13:34:45   cp    -         29     323163
>                 10346  2009-05-25 13:34:46   cp    i       6679     323163
>                 10347  2009-05-25 13:34:51   cp    i       6669     323163
>                 10348  2009-05-25 13:34:56   cp    i       6675     323163
>                 10349  2009-05-25 13:35:01   cp    i       6676     323163
>                 10350  2009-05-25 13:35:06   cp    i       6649     323163
>                 10351  2009-05-25 13:35:11   cp    i       6679     323163
> 
> 
> It would also be nice to change the cp/clean interval without editing 
> the conf file, perhaps during the nite we can had different checkpoint 
> intervals and during work a smaller cp interval.

Checkpoint creation is essential to nilfs writes, so this seems to be
difficult without introducing some kind of invisible checkpoint.
(checkpoint removal is much easier, but I understood what you want
 slightly differs from such external )

I think it needs care because the feature partially invalidate what
the nilfs stands for.  Maybe 5 seconds checkpoining should be remained
as default.  But some flexiblity might well be allowed as you pointed
out.

Supporting method changing cleaning interval without editing the conf
file, sounds reasonable (yes, sorry for inconvenience).
 
> Finally instead of having 5 commands, it'd be nice to have once command 
> with different options (like zfs). So instead have
> 
> . nilfs checkpoint
> . nilfs snapshot
> . nilfs remove
> . nilfs list
> . nilfs suspend
> . nilfs restart
> etc...

Yeah, I agree reorganizing commands into one 'nilfs' command is
preferable.  Well, I'll add this to the todo items on the site.

I think it would be nice if the old commands are available through
symbolic links to this unified command according to user's
predilection.
 
> All seems to be working fine so far, so take this as constructive comments.
>
> Cheers
> Dave

Thank you for many productive comments!

 
Regards,
Ryusuke Konishi
