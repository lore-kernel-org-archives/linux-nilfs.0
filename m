From: "Dipl.-Ing. Michael Niederle" <mniederle-RbZlAiThDcE@public.gmane.org>
Subject: Re: Snapshot
Date: Sat, 27 Jun 2009 11:52:34 +0200
Message-ID: <20090627115234.4a099427@simplux>
References: <mailman.1.1246071601.2080.users@nilfs.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <mailman.1.1246071601.2080.users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
Cc: Stephane Krikorian <rastaman-QFKgK+z4sOrR7s880joybQ@public.gmane.org>

Hi, Stephane!

> 1/ I take a snapshot
> 2/ I apply a patch
> 3/ I test my application
> 4/ I decide to revert to the state of the snapshot discarding the changes 
> caused by the patch and subsequent testing.

>Is it possible since snaphots can only be mounted R/O ? Do I have to rsync 
> my R/O snapshot with my partition ? Thanks for enlightning me.
> Stephane

Currently you cannot revert to a previous snapshot. Due to information from
Ryusuke Konishi the current data structures don't support this.

So for now you will have to rely on rsync or a similar tool.

Greetings, Michael
