From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Nilfs Code Documentation
Date: Wed, 05 Nov 2008 14:50:21 +0900 (JST)
Message-ID: <20081105.145021.88493966.ryusuke@osrg.net>
References: <3a5a8cdc0811031241j633e5931r671710f3fce4f48d@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <3a5a8cdc0811031241j633e5931r671710f3fce4f48d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, s.himadri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,

On Mon, 3 Nov 2008 15:41:01 -0500, "Himadri Sarkar" wrote:
> Where can I get nilfs code documentation? When I generate documentation
> using Doxygen then very less documentation is generated as  the code is not
> in doxygen format. Please help me in this regard.

If you have kernel sources, please try kernel-doc script as follows:

 $ /usr/src/linux-2.6.xx/scripts/kernel-doc -html nilfs2-modules/fs/*.[ch]
   > index.html

The produced document is still insufficient, though.

I'm not familiar with the Doxygen, but it seems not working well
against kernel code.

With regards,
Ryusuke Konishi
