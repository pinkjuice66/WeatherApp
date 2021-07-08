//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Jade on 2021/07/03.
//

import UIKit

class DetailWeatherViewController: UIViewController {

    private var pageController: UIPageViewController?
    var initialIndex: Int!
    let weatherViewModel = WeatherViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setUpPageController()
    }
    
    // pageController의 property 설정, 초기 content 설정
    private func setUpPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self
        addChild(pageController!)
        view.addSubview((pageController?.view)!)
        pageController!.view.backgroundColor = .black
    
        let button = UIButton()
        let image = UIImage(systemName: "list.bullet")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        pageController!.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: pageController!.view.trailingAnchor, constant: -20).isActive = true
        button.bottomAnchor.constraint(equalTo: pageController!.view.bottomAnchor, constant: -30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.addTarget(self, action: #selector(weatherListButtonClicked), for: .touchUpInside)
        
        guard let initialViewController = getPageItemViewController() else { return }
        initialViewController.indexOfCurrentPage = initialIndex
        
        pageController?.setViewControllers([initialViewController],
                                           direction: .forward,
                                           animated: true, completion: nil)
        pageController?.didMove(toParent: self)
    }

    
    // page 화면 하나를 담당하는 View Controller를 만들어서 반환한다.
    private func getPageItemViewController() -> WeatherPageItemViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController =
                storyboard.instantiateViewController(identifier: "WeatherPageItemViewController") as? WeatherPageItemViewController else { return nil }
        
        return viewController
    }
    
    @objc private func weatherListButtonClicked() {
        navigationController?.popViewController(animated: true)
    }

}

extension DetailWeatherViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let current = viewController as? WeatherPageItemViewController,
           current.indexOfCurrentPage != 0 else { return nil }
        guard let vc = getPageItemViewController() else { return nil }
        vc.indexOfCurrentPage = current.indexOfCurrentPage! - 1
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let current = viewController as? WeatherPageItemViewController,
              current.indexOfCurrentPage != weatherViewModel.getCities().count - 1 else { return nil }
        
        guard let vc = getPageItemViewController() else { return nil }
        vc.indexOfCurrentPage = current.indexOfCurrentPage! + 1
        
        return vc
    }
    
}

extension DetailWeatherViewController: UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return weatherViewModel.getCities().count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let vc = pageController?.viewControllers?.first
                as? WeatherPageItemViewController else { return 0 }
        
        return vc.indexOfCurrentPage!
    }
    
}
