From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Crash bug, was cleanerd stopping
Date: Sun, 28 Dec 2008 12:22:01 +0900 (JST)
Message-ID: <20081228.122201.64850929.ryusuke@osrg.net>
References: <4956A4D6.2010004@mib-infotech.co.nz>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4956A4D6.2010004-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org

Hi John,
On Sun, 28 Dec 2008 10:57:42 +1300, John Huttley wrote:
> Hi Ryusuke,
> 
> I built from your git repo.
> 
> It seemed to work for the first few days, then it crashed and now its 
> hard crashed with the following
> message

Sorry for the inconvenience.
The log shows that destruction of btree was occurred.

I'm now doing a stress test against the latest nilfs of the git repo,
but I feel my Debian environment is unsuited to reproduce your problem.

You are using gentoo 2008.0 (2.6.26-gentoo), aren't you?
I'd like to do the stress test on a similar environment.

Could you tell me which IMAP daemon you were using on the nilfs
partition? (courier-imap?)

Regards,
Ryusuke
