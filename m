From: "Dipl.-Ing. Michael Niederle" <mniederle-RbZlAiThDcE@public.gmane.org>
Subject: Data Loss
Date: Fri, 12 Jun 2009 01:10:57 +0200
Message-ID: <20090612011057.547c70c1@simplux>
References: <mailman.37.1244739111.2282.users@nilfs.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <mailman.37.1244739111.2282.users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

It's absolutely strange: nilfs seems to crash during idle times!

This time everything seemed to be fine when I returned to my PC after several
hours. Astonishingly my pen drive's LED reported heavy activity despite the
fact that there was nothing to do. I have a script that detects recently
changed files. This script reported that not a single file had been changed
during the last hour!

After a reboot the system got stuck when trying to pivot_root to the
nilfs-root-file-system (no problem mounting it). An analysis showed that
several files had been destroyed. The stat-utility showed the file type
"weird". ^^

I also mounted some elder checkpoints. They now had defect files, too.

In my opinion the cleaner daemon is causing all these problems but - as always -
I might be wrong.

As to my knowledge there is currently no way to repair a nilfs-file-system?

Greetings, Michael
