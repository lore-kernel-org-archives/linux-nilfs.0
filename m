From: "Dipl.-Ing. Michael Niederle" <mniederle-RbZlAiThDcE@public.gmane.org>
Subject: Re: users Digest, Vol 38, Issue 14
Date: Fri, 15 May 2009 10:37:24 +0200
Message-ID: <20090515103724.5dd3285b@simplux>
References: <mailman.1.1242356401.18832.users@nilfs.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <mailman.1.1242356401.18832.users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

Hi, Ryusuke!

> BTW, could you try switching IO scheduler to "noop" ?

I'm already using the NOOP-scheduler.

The nilfs is the root file system of my life-system. The two crashes occured
before I converted a checkpoint to a snapshot. At the time the data losses
occured there existed only checkpoints. I don't know whether this could matter
or not.

> What is your pendrive product?

I have several pen drives for testing (from Corsair, OCZ, SanDisk). I'm
currently testing nilfs on a "SanDisk Curzer Contour (16GB)". Initially I used
kernel 2.6.30rc4, but switched to rc5 recently. The new kernel was build under
nilfs - quickly and without any problems.

The problem of a pen based Linux system is, that it is more likely to be just
disconnected instead of beeing shutdown cleanly than a desktop system.

Loosing current data will be no problem. Loosing the whole filesystem is a
big problem ...

Greetings, Michael
