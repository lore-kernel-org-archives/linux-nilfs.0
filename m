From: "Dipl.-Ing. Michael Niederle" <mniederle-RbZlAiThDcE@public.gmane.org>
Subject: Some problems
Date: Sat, 23 May 2009 22:11:20 +0200
Message-ID: <20090523221120.086a1002@simplux>
References: <mailman.1.1243047601.4877.users@nilfs.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <mailman.1.1243047601.4877.users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

Hi!

I continue testing nilfs as a root file system. Until now I have no script to
cleanly unmount the root file system. (In the layered approach (aufs) I used
before this was not necessary.) So I just called sync and then shut down the
system.

The next boot took some time, because the superblock was "broken". Here an
extract from the kernel log:

[    1.407323] NILFS warning: broken superblock. using spare superblock.
[    1.408569] NILFS warning: broken superblock. using spare superblock.
[  461.587031] segctord starting. Construction interval = 5 seconds, CP
frequency < 30 seconds [  461.591873] NILFS warning: mounting unchecked fs
[  461.629865] NILFS: recovery complete.

Is nilfs doing a sequential scan over the whole partition to find its spare
superblock?

Then I wanted to remove some snapshots:

> lscp -s
                 CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
                 685  2009-05-13 09:38:20   ss    -         35     568722
                1330  2009-05-13 10:59:41   ss    i       7629     579584
                4466  2009-05-14 19:15:28   ss    -         23     589270
                8250  2009-05-16 03:40:42   ss    i       6202     597141
                9910  2009-05-17 19:14:54   ss    -         49     626715
               10380  2009-05-17 20:21:53   ss    -         18     647228
               10620  2009-05-23 21:45:41   ss    i       6054     646978

>rmcp 685
rmcp: 685: operation not permitted

What's the cause of this message? (rmcp also failed for all other snapshots;
the failed rmcp did not produce any kernel message)

Greetings, Michael
