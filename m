From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] resizing file system
Date: Wed, 08 Apr 2009 02:30:05 +0900 (JST)
Message-ID: <20090408.023005.48479195.ryusuke@osrg.net>
References: <BAEFA5609CC3AB4BAE1625CAD4C27E5C02986E1D@tdpost.td.tandbergdata.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <BAEFA5609CC3AB4BAE1625CAD4C27E5C02986E1D-qPLjlnsG5hmCmmEZ8mJCX5vx1ZQ4fP860E9HWUfgJXw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, FMunro-/3AnZwnt+WyVkR+q5Y5grQ@public.gmane.org

Hi!
On Tue, 7 Apr 2009 10:57:23 -0600, "Munro, Fred" wrote:
> I need to grow my partition and my FS.  In the future, I will may need
> to shrink it.  Is there a way to resize my nilfs2 fs - something similar
> to resize2fs for ext2/3?

An experimental resize feature did exist, but it's not applicable to
the current version.  And, it didn't support shrinking.
So the feature you want is not available now.  (Sorry for inconvenience)

I think it's not difficult, but I'm busy with support of mainline
merging now.  I'd like to address such todo features again after it
gets settled.

Regards,
Ryusuke Konishi
