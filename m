From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: how to delete files and use space (simple
 question)
Date: Fri, 12 Jun 2009 13:18:36 +0900 (JST)
Message-ID: <20090612.131836.15813470.ryusuke@osrg.net>
References: <COL116-W45012F60AE4E85CC618BDDC0420@phx.gbl>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <COL116-W45012F60AE4E85CC618BDDC0420-MsuGFMq8XAE@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, biophysics-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org

Hi,
On Thu, 11 Jun 2009 15:15:41 +0200, Karthik P S wrote:
> Hi 
> I am planning to install nilfs in my laptop (ubuntu/jaunty) . I was
> wondering is it possible to delete files and reclaim space from this
> file system.
>
> If my disk is 75 % full then if I delete a file that is located in
> the first 10 % of the file system how will this space will be
> available for user ? Will files move automatically to the blank
> space ?
>
> Sorry for asking this simple question 
> 
> Best regards,
> Karthik

In nilfs, a background garbage colletor detects unused disk blocks and
make them reusable.  The disk space is reclaimed per ``segment''.

Try lssu command.  It will show you the usage state of the partition like:

              SEGNUM        DATE     TIME STAT     NBLOCKS
                   2  2009-06-09 00:51:03  -d-        2048
                   3  2009-06-09 00:51:03  -d-        2048
                   4  2009-06-09 00:51:03  -d-        2048
                   5  2009-06-09 00:51:03  -d-        2048
                   6  2009-06-09 00:51:03  -d-        2048
                   7  2009-06-09 00:51:03  -d-        2048
                   8  2009-06-09 00:51:03  -d-        2048
                   9  2009-06-09 00:51:03  -d-        2048
                   ...

After 1 hour you have made a change on the partition, the garbage
collector will start.  The lssu output above will change with time.

Cheers,
Ryusuke Konishi
