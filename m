From: Dave <dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
Subject: Nilfs features
Date: Mon, 25 May 2009 13:46:14 +0400
Message-ID: <4A1A68E6.50905@0bits.com>
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

Hi,

I converted (backup/restore) my home directory onto nilfs2 to test it in 
anger  (yes i know the caveats about it corrupting all my data, etc, but 
i'm willing to restore when required).

When restoring the data onto a nilfs2 filesystem there really is no 
requirement to have the checkpointing running as you have a good copy 
from your tar, cpio archive that you are restoring from. So is there a 
way to temporarily suspend checkpointing with a command and then restart 
it after the restore has completed ? I think this would be useful also 
for when  you want to have a 'privacy' mode (like firefox/mozilla) where 
you can suspend checkpointing, start some confidential work, email, 
browsing etc, and then restart checkpointing and roll back to the 
previous state.

In addition to this there doesn't seem to be a way to delete a range of 
checkpoints. When i did my restore from my archive, i generated 700+ 
useless checkpoints which i had to delete one by one (in a script). It 
would be nice to have a 'rmcp 1-100' or 'rmcp -100' or 'rmcp 100-' to 
delete a checkpoint range, a start to end.

Also it seems for home directories, a 5 second checkpointing seems 
exessive. In 14hrs i have 10,000 checkpoints (even when seemingly idle 
with mozilla page refreshes, dovecot index files updates  for email, etc).


home:~$ uptime
  13:35:09 up 14:29,  7 users,  load average: 0.85, 1.76, 2.07
home:~$ lscp|tail
                10342  2009-05-25 13:34:31   cp    i       6698     323163
                10343  2009-05-25 13:34:36   cp    -       6761     323163
                10344  2009-05-25 13:34:41   cp    i       6702     323163
                10345  2009-05-25 13:34:45   cp    -         29     323163
                10346  2009-05-25 13:34:46   cp    i       6679     323163
                10347  2009-05-25 13:34:51   cp    i       6669     323163
                10348  2009-05-25 13:34:56   cp    i       6675     323163
                10349  2009-05-25 13:35:01   cp    i       6676     323163
                10350  2009-05-25 13:35:06   cp    i       6649     323163
                10351  2009-05-25 13:35:11   cp    i       6679     323163


It would also be nice to change the cp/clean interval without editing 
the conf file, perhaps during the nite we can had different checkpoint 
intervals and during work a smaller cp interval.


Finally instead of having 5 commands, it'd be nice to have once command 
with different options (like zfs). So instead have

. nilfs checkpoint
. nilfs snapshot
. nilfs remove
. nilfs list
. nilfs suspend
. nilfs restart
etc...

All seems to be working fine so far, so take this as constructive comments.

Cheers
Dave
