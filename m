From: Alexander Schier <alex-W0ZHf6uU1cg@public.gmane.org>
Subject: Re: Kernel Bug while deleting files (with rsync)
Date: Fri, 28 Mar 2008 19:12:11 +0100
Message-ID: <20080328181211.GA19581@laxu.de>
References: <20080325102553.GA10853@laxu.de>
	<1206445521.3131.60.camel@localhost.localdomain>
	<20080326.220532.62697306.ryusuke@osrg.net>
	<20080326164723.GA31518@laxu.de>
	<1206587021.3100.47.camel@localhost.localdomain>
	<20080327132327.GA3562@laxu.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080327132327.GA3562-W0ZHf6uU1cg@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi!
It keeps reproducable, now even just after starting rsync:
> rsync -avPz --delete /home/allo/ /media/backup2/allo/
sending incremental file list

(bug on remotehost)
