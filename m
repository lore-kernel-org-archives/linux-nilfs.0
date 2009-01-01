From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel Bug after corrupted filesystem
Date: Fri, 02 Jan 2009 00:27:35 +0900 (JST)
Message-ID: <20090102.002735.88475791.ryusuke@osrg.net>
References: <20081231111707.25420@gmx.net>
	<20081231.233620.76970897.ryusuke@osrg.net>
	<20090101093121.302730@gmx.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090101093121.302730-hi6Y0CQ0nG0@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, robinx99-hi6Y0CQ0nG0@public.gmane.org

Happy new year,
On Thu, 01 Jan 2009 10:31:21 +0100, robinx99-hi6Y0CQ0nG0@public.gmane.org wrote:
> Hi and happy new year,
> ok have done that and atached the log hope this information is usefull and I hope this helps to further improve nilfs
> 
> Robinx99

Thanks for your help.
I have another request:

 # dumpseg /dev/loop1 12

 - This will dump the summary of the segment in question

 # dd if=/dev/loop1 bs=4k skip=24576 count=2 | hd

 - This will dump the (broken) root block of the file system

According to your log, the btree root of DAT file (i.e. a table file
to translate disk addresses) seems inconsistent.  It might not be
updated properly when GC moved its blocks.  I suspect that it was
caused by some sort of GC problem.

And, your nilfs partition seems to have shut down uncleanly before
this mount error repeatedly happened.  Do you remember what the first
trouble was like?

Regards,
Ryusuke
